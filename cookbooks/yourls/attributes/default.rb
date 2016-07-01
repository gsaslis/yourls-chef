default['yourls']['url'] = 'https://github.com/YOURLS/YOURLS/archive/1.7.1.tar.gz'
default['yourls']['path'] = node['apache']['docroot_dir']
default['yourls']['checksum'] = ''
default['apache']['listen'] = [ '*:8880' ]

# TODO: replace these with something more secure (encrypted data bag, chef vault)
default['yourls']['mysql_root_pass'] = 'bC}t79BtpYNs+k]BZu+MzY'
default['yourls']['mysql_yourls_pass'] = 'LQ=>sz4ZshKEkmL}vh;2yH'