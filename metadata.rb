name             'scpr-elasticsearch'
maintainer       'Southern California Public Radio'
maintainer_email 'erichardson@scpr.org'
license          'apache2'
description      'Installs/Configures scpr-elasticsearch'
long_description 'Installs/Configures scpr-elasticsearch'
version          '0.3.0'

depends "scpr-java"
depends "elasticsearch", "~> 1.2.0"
depends "scpr-consul", "~> 0.1.25"