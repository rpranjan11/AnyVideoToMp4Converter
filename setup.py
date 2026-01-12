from setuptools import setup

APP = ['converter.py']
DATA_FILES = []
OPTIONS = {
    'argv_emulation': False,
    'plist': {
        'CFBundleName': 'AnyVideoToMp4Converter',
        'CFBundleDisplayName': 'AnyVideoToMp4Converter',
        'CFBundleIdentifier': 'com.rpranjan11.anyvideotomp4',
        'CFBundleVersion': '0.1.0',
        'CFBundleShortVersionString': '0.1.0',
    }
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
