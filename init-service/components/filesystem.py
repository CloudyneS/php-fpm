import os
import tempfile
import urllib.request
from git import Repo
# from extractcode import extract
import patoolib
from .helpers import equals_false, equals_empty, colored

"""
Inputs:
    FS_CHECK_PATH: Path to check for existence
    FS_CHECK_PATH_TYPE: What to check for in the path (FILE, DIR, ANY)
    FS_CHECK_ACTION_ONFAIL: What to do if the path doesn't exist (FAIL, CREATEDIR, TOUCH, IGNORE)
    
    FS_FILL_PATH: Path to fill with files (Supports GIT and .tar, .zip, .tar.gz, .gz, .rar)
    FS_FILL_EMPTY_PATH_ONLY: Only fill the path if it's empty
    FS_FILL_PATH_FROM: What source to use to fill the path (GIT, ARCHIVE_URL, ARCHIVE_LOCAL)
    FS_FILL_PATH_DATA: The URL or path to the PATH_FROM type, e.g. https://github.com/abc/def.git@@BRANCH for git, https://example.com/archive.zip for ARCHIVE_URL and /tmp/archive.zip for ARCHIVE_LOCAL
    FS_FILL_PATH_ONFAIL: What to do in case of failure (FAIL, IGNORE)
    
    FS_CLEANUP_ITEMS: Comma-separated list of paths to remove at the end of the process    
"""
class Filesystem:
    def __init__(self, config):
        self.config = config
   
    def run(self):
        print(colored("HEADER", "Running Filesystem checks..."))
        try:
            print("Checking if path exists...", self.checkPath(
                path=self.config.get('FS_CHECK_PATH', False),
                ptype=self.config.get('FS_CHECK_PATH_TYPE', 'ANY'),
                onfail=self.config.get('FS_CHECK_ACTION_ONFAIL', 'FAIL')
            ))
        except Exception as e:
            if self.config.get('FS_CHECK_ACTION_ONFAIL', 'FAIL') == 'FAIL':
                raise e

        try:
            print("Filling path...", self.fillPath(
                path=self.config.get('FS_FILL_PATH', False),
                empty_only=self.config.get('FS_FILL_EMPTY_PATH_ONLY', True),
                fill_from=self.config.get('FS_FILL_PATH_FROM', 'GIT'),
                fill_data=self.config.get('FS_FILL_PATH_DATA', False)
            ))
        except Exception as e:
            if self.config.get('FS_FILL_PATH_ONFAIL', 'FAIL') == 'FAIL':
                raise Exception(e)
        
        try:
            print("Running cleanup...", self.pathCleanup(
                items=self.config.get('FS_CLEANUP_ITEMS', False)
            ))
        except Exception as e:
            print(e)
 
    def checkPath(self, path, ptype, onfail):
        err = ""
        if not equals_empty(path):
            if os.path.exists(path):
                if ptype == 'ANY':
                    return colored('GREEN', 'OK')
                
                if ptype == 'FILE' and os.path.isfile(path):
                    return colored('GREEN', 'OK')
                
                if ptype == 'DIR' and os.path.isdir(path):
                    return colored('GREEN', 'OK')

            if onfail == 'FAIL':
                raise Exception(
                    colored('FAIL', f'Path {path} does not fulfill condition (IS_{ptype})')
                )
            
            if onfail == 'CREATEDIR':
                os.makedirs(path)
                return colored("GREEN", "DIR CREATED")
            
            if onfail == 'TOUCH':
                os.mknod(path)
                return colored("GREEN", "FILE TOUCHED")
            
            return colored("WARNING", "FAILED")
    
    def fillPath(self, path, empty_only, fill_from, fill_data):
        if sum(equals_empty(x) for x in [path, fill_from, fill_data]) == 0:
            # Create path if it doesn't exist
            if not os.path.exists(path):
                os.makedirs(path)

            if empty_only and len(os.listdir(path)) > 0:
                return colored("BLUE", "SKIPPED, NOT EMPTY")

            if fill_from == 'GIT':
                giturl, gitbranch = fill_data.split('@@')
                gitrepo = Repo.clone_from(giturl, path)
                if gitrepo.active_branch.name != gitbranch:
                    getattr(gitrepo.heads, gitbranch).checkout()
                
                os.system(f'ls -al {path}/')
                return colored("GREEN", "OK")
            
            if fill_from in ['ARCHIVE_URL', 'ARCHIVE_LOCAL']:
                archive_path = fill_data
            
                if fill_from == 'ARCHIVE_URL':
                    with urllib.request.urlopen(fill_data) as resp:
                        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
                            temp_file.write(resp.read())
                            archive_path = temp_file.name
                print(open(archive_path, 'rb').read(100))

                patoolib.extract_archive(
                    archive=archive_path,
                    verbosity=0,
                    outdir=path,
                    interactive=False
                )
                os.system(f'ls -al {path}/')
                return colored("GREEN", "OK")
                
        return colored("WARNING", "FAILED, NO VALID CONFIGURATION")
    
    def pathCleanup(self, items):
        if not equals_empty(items):
            for item in items.split(','):
                if os.path.exists(item):
                    if os.path.isfile(item):
                        os.remove(item)
                    else:
                        os.rmdir(item)
            return colored("GREEN", "OK")
        
        return colored("WARNING", "SKIPPED, NO ITEMS TO CLEAN UP")