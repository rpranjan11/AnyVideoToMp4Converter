import os
import subprocess
import threading
import time
import webview
from pathlib import Path

# --- CONFIGURATION ---
def get_ffmpeg_path():
    # Check if we are running in a bundled app (PyInstaller)
    if hasattr(sys, '_MEIPASS'):
        bundled_ffmpeg = os.path.join(sys._MEIPASS, 'bin', 'ffmpeg')
        if os.path.exists(bundled_ffmpeg):
            return bundled_ffmpeg
    
    # Fallback to local bin folder (for development)
    local_bin = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'bin', 'ffmpeg')
    if os.path.exists(local_bin):
        return local_bin

    # Fallback to system path
    try:
        return subprocess.check_output(['which', 'ffmpeg']).decode().strip()
    except:
        return '/opt/homebrew/bin/ffmpeg'

FFMPEG_PATH = get_ffmpeg_path()

CPU_THREADS = '10'
CPU_PRIORITY = '19'

class Api:
    def __init__(self):
        self._window = None
        self.files = []
        self.is_processing = False
        self.current_process = None
        self.stop_requested = False

    def set_window(self, window):
        self._window = window

    def select_files(self):
        # Multiple file selection
        file_paths = self._window.create_file_dialog(webview.OPEN_DIALOG, allow_multiple=True)
        if file_paths:
            for path in file_paths:
                # Avoid duplicates
                if not any(f['path'] == path for f in self.files):
                    self.files.append({
                        'path': path,
                        'name': os.path.basename(path),
                        'status': 'pending',
                        'status_text': 'Pending'
                    })
            self._update_frontend()

    def clear_list(self):
        if self.is_processing:
            return
        self.files = []
        self._update_frontend()

    def locate_file(self, path):
        # Open in Finder and select file
        subprocess.run(['open', '-R', path])

    def start_conversion(self):
        if not self.files or self.is_processing:
            return
        
        self.is_processing = True
        self.stop_requested = False
        self._set_processing_state(True)
        
        # Run in a separate thread to keep UI responsive
        threading.Thread(target=self._process_queue, daemon=True).start()

    def stop_conversion(self):
        if not self.is_processing:
            return
        self.stop_requested = True
        if self.current_process:
            self.current_process.terminate()
        self.is_processing = False
        self._set_processing_state(False)

    def _process_queue(self):
        for file_data in self.files:
            if self.stop_requested:
                break
            
            if file_data['status'] == 'done':
                continue

            file_data['status'] = 'processing'
            file_data['status_text'] = 'Processing...'
            self._update_frontend()

            success = self._transcode(file_data['path'])
            
            if self.stop_requested:
                file_data['status'] = 'pending'
                file_data['status_text'] = 'Stopped'
            elif success:
                file_data['status'] = 'done'
                file_data['status_text'] = 'Finished'
            else:
                file_data['status'] = 'error'
                file_data['status_text'] = 'Error'
            
            self._update_frontend()

        self.is_processing = False
        self._set_processing_state(False)

    def _transcode(self, file_path):
        path_obj = Path(file_path)
        final_output = path_obj.with_suffix('.mp4')
        
        if final_output.exists() and final_output.resolve() == path_obj.resolve():
             final_output = path_obj.with_name(path_obj.stem + "_converted.mp4")

        temp_output = path_obj.with_suffix('.temp.mp4')
        if temp_output.exists():
            os.remove(temp_output)

        # Basic analysis (simplified for this iteration, can be expanded)
        # Using the same logic as before to detect h264/aac
        is_video_h264, is_audio_aac = self._get_stream_info(file_path)

        cmd = [
            FFMPEG_PATH, '-hide_banner', '-loglevel', 'error', '-stats',
            '-threads', CPU_THREADS, '-i', str(path_obj),
            '-map', '0:v', '-map', '0:a?',
        ]

        if is_video_h264:
            cmd.extend(['-c:v', 'copy'])
        else:
            cmd.extend([
                '-c:v', 'libx264', '-crf', '18', '-preset', 'slow',
                '-profile:v', 'high', '-level', '4.1', '-pix_fmt', 'yuv420p'
            ])

        if is_audio_aac:
            cmd.extend(['-c:a', 'copy'])
        else:
            cmd.extend(['-c:a', 'aac', '-b:a', '160k'])

        cmd.extend(['-movflags', '+faststart', '-y', str(temp_output)])
        
        full_cmd = ['nice', '-n', CPU_PRIORITY] + cmd

        try:
            self.current_process = subprocess.Popen(full_cmd, stderr=subprocess.PIPE)
            self.current_process.wait()
            
            if self.current_process.returncode == 0:
                os.rename(temp_output, final_output)
                return True
            else:
                if temp_output.exists(): os.remove(temp_output)
                return False
        except Exception:
            if temp_output.exists(): os.remove(temp_output)
            return False
        finally:
            self.current_process = None

    def _get_stream_info(self, file_path):
        try:
            result = subprocess.run(
                [FFMPEG_PATH, '-hide_banner', '-i', str(file_path)],
                stderr=subprocess.PIPE, text=True
            )
            output = result.stderr
            is_h264 = "Video: h264" in output
            is_aac = "Audio: aac" in output
            return is_h264, is_aac
        except:
            return False, False

    def _update_frontend(self):
        if self._window:
            self._window.evaluate_js(f"updateUI({self.files})")

    def _set_processing_state(self, is_processing):
        if self._window:
            self._window.evaluate_js(f"updateProcessingState({str(is_processing).lower()})")

if __name__ == '__main__':
    api = Api()
    # Find the HTML file path
    current_dir = os.path.dirname(os.path.abspath(__file__))
    html_path = os.path.join(current_dir, 'ui', 'index.html')
    
    window = webview.create_window(
        'AnyVideoToMp4Converter',
        html_path,
        js_api=api,
        width=800,
        height=600,
        min_size=(600, 500)
    )
    api.set_window(window)
    webview.start(debug=False)
