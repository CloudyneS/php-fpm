from .helpers import equals_false, equals_empty, colored

"""
Inputs:
    CI_BASE_PATH: Base path to Codeigniter installation (empty deactivates plugin)
    CI_BASE_PATH_CHECK: Check if the base path exists (true/false)
    CI_BASE_PATH_CHECK_ONFAIL: What to do if the check fails (FAIL/IGNORE)
    CI_INSTALL_CI: Install Codeigniter (true/false)
    CI_INSTALL_CI_ONFAIL: What to do if installation fails (FAIL/IGNORE)
    CI_MAKE_MIGRATIONS: Make migrations (true/false)
    CI_MAKE_MIGRATIONS_ONFAIL: What to do if migrations fail (FAIL/IGNORE)
    CI_DO_MIGRATIONS: Do migrations (true/false)
    CI_DO_MIGRATIONS_ONFAIL: What to do if migrations fail (FAIL/IGNORE)
"""
class Codeigniter:
    def __init__(self, config):
        self.config = config
   
    def run(self):
        print(colored("HEADER", "Running Codeigniter initialization..."))