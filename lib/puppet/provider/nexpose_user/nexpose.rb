require 'securerandom'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'nexpose'))
Puppet::Type.type(:nexpose_user).provide(:nexpose, :parent => Puppet::Provider::Nexpose ) do

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
    #This sets @property_hash
    nsc = connection
    nsc.login 
    nsc.users.collect do |user_summary|
      user = User.load(nsc, user_summary.id)
      Puppet.debug("Collecting #{user.name}")
      result = { :ensure => :present }
      result[:name] = user.name
      result[:full_name] = user.full_name
      result[:email] = user.email
      result[:role] = user.role_name
      result[:enabled] =  (! user.enabled.zero?).to_s
      new(result)
    end
  end

  def password
    Puppet.debug("check #{@resource[:name]} #{@resource[:password]}")
    @password = @resource[:password] ? @resource[:password] : 'nxpassword'
    if check_password(@resource[:name], @password)
      @resource[:password]
    else
      false
    end
  end

  def flush
    @full_name =  @property_flush.key?(:full_name)? @property_flush[:full_name] : @resource[:full_name]
    @email     =  @property_flush.key?(:email)? @property_flush[:email] : @resource[:email]
    @role      =  @property_flush.key?(:role)? @property_flush[:role] : @resource[:role]
    @enabled   =  @property_flush.key?(:enabled)? @property_flush[:enabled] : @resource[:enabled]
    @password  =  @resource[:password]

    if not @password
      Puppet.warning("***INSECURE*** nexpose_user[#{@resource[:name]}]: no password set using default ")
      @password = 'nxpassword'
    end


    nsc = connection
    nsc.login
    user_summary = nsc.users.find { |user| user.name == @resource[:name] }
    if @property_flush[:ensure] == :absent
      if user_summary 
        Puppet.debug("delete #{@resource[:name]}")
        nsc.delete_user(user_summary.id)
      end
    else
      if user_summary 
        Puppet.debug("update #{@resource[:name]}")
        user = User.load(nsc, user_summary.id)
        user.full_name  = @full_name
        user.email      = @email
        user.role_name  = @role  
        user.enabled    = @enabled.to_s == 'true'? 1 : 0
        user.password = @password

        user.save(nsc)
      else
        Puppet.debug("add #{@resource[:name]}, #{@full_name}, #{@password}, #{@role}")
        user = User.new(@resource[:name], @full_name, @password, @role.to_s)
        user.email     = @email
        user.enabled = @enabled.to_s == 'true'? 1 : 0
        user.save(nsc)
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
