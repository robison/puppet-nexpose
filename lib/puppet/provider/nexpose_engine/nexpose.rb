require File.expand_path(File.join(File.dirname(__FILE__), '..', 'nexpose'))
Puppet::Type.type(:nexpose_engine).provide(:nexpose, :parent => Puppet::Provider::Nexpose ) do

  defaultfor :kernel => 'Linux'
  mk_resource_methods
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.instances
    nsc = connection
    nsc.login
    nsc.engines.collect do |engine_summary|
      engine = Engine.load(nsc, engine_summary.id)
      Puppet.debug("Collecting #{engine.name}")
      result = { :ensure => :present }
      result[:name] = engine.name
      result[:address] = engine.address

      new(result)
    end
  end

  def flush
    @name =  @property_flush.key?(:name)? @property_flush[:name] : @resource[:name]
    nsc = connection
    nsc.login
    engine_summary = nsc.list_engines.find { |engine| engine.id == @resource[:id] }
    if @property_flush[:ensure] == :absent
      if site_summary
        Puppet.debug("delete #{@resource[:name]}")
        nsc.delete_engine(engine_summary.id)
      end
    else
      if engine_summary
        Puppet.debug("update #{@resource[:name]}")
        engine = Engine.load(nsc, engine_summary.id)
        engine.name   = @name
        engine.save(nsc)
      else
        Puppet.debug("add #{@resource[:name]}")
        engine = Engine.new(@resource[:address], @resource[:name], @resource[:port])
        engine.name = @name
        engine.save(nsc)
      end
    end
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def exists?
    @property_hash[:ensure] == :present
  end

end