from .helpers import equals_false, equals_empty, colored

"""
Inputs:
    WP_CONFIG_PATH: Path to configuration file or wp-cli.yml
    WP_CONFIG_TYPE: Type of configuration file (env/wp-config.php)
    WP_CONFIG_DB_WORKS: Check if the database works with the current configuration (true/false)
    WP_CONFIG_SET__XXXXX: Set a configuration value (attn: two underscores before name)(e.g. WP_CONFIG_SET__SITEURL: https://google.com)
    WP_CONFIG_VALIDATE_AFTER_SET: Validate DB works after settings config variables (true/false)
    WP_GENERATE_NEW_SALTS: Generates new salts for the configuration file (true/false)
    WP_GENERATE_NEW_SALTS_ONFAIL: What to do if the generation fails (FAIL/IGNORE)
    WP_IMPORT_DATABASE: Imports a database from a file (exported with wp db export)
    WP_INSTALL_PLUGINS: Comma-separated list of plugins to install
    WP_ACTIVATE_PLUGINS: Comma-separated lsit of plugins to install
    WP_INSTALL_MU_PLUGINS: Comma-separated list of mu-plugins to install
"""
class Wordpress:
    def __init__(self, config):
        self.config = config
   
    def run(self):
        print(colored("HEADER", "Running Wordpress initialization..."))