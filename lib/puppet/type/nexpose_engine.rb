Puppet::Type.newtype(:nexpose_engine) do
    @doc = 'This type provides the capability to manage scan engines in NeXpose'

    ensurable

    newparam(:name, :namevar => true) do
        desc 'Name of the engine'
    end
    newproperty(:address ) do
        desc 'IP address or FQDN of the engine'
        isrequired
    end
    newproperty(:priority ) do
        desc 'Relative priority of the scan engine'
    end
    newproperty(:sites ) do
        desc 'Sites to which the scan engine is assigned'
    end
    newproperty(:scope ) do
        desc 'Whether the engine has a global or silo-specific scope'
    end
    newproperty(:port ) do
        desc 'The port on which the engine listens for requests from the security console.'
        isrequired
    end 
end