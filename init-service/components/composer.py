from .helpers import equals_false, equals_empty, colored

"""
Inputs:
    COMPOSER_CHECK_CONFIGFILE: Searches for a valid composer configuration at the current path
    COMPOSER_CHECK_CONFIGFILE_ONFAIL: What to do if the check fails (FAIL/IGNORE)
    COMPOSER_RUN: False, or which composer command to run (install/update + any parameters)
    COMPOSER_RUN_PATH: Path to run composer from
    COMPOSER_RUN_ONFAIL: What to do if the run fails (FAIL/IGNORE)
"""
class Composer:
    def __init__(self, config):
        self.config = config
   
    def run(self):
        print(colored("HEADER", "Running Composer initialization..."))