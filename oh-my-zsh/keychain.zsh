# Add all ssh keys on the machine we are working on
# Might add a script later that installs all these with the ssh keys available
# per machine, but for now add them manually
eval `keychain --eval --agents ssh redpill-laptop`
eval `keychain --eval --agents ssh gh_mikosaur`

