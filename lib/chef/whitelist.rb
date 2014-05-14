
require 'chef/exceptions'

class Chef
  class Whitelist

    def self.filter(data, whitelist=nil)
      return data if whitelist.nil?

      new_data = {}
      whitelist.each do |item|
        self.add_data(data, new_data, item)
      end
      new_data
    end

    private

    def self.add_data(data, new_data, item)
      parts = self.to_array(item)

      all_data = data
      filtered_data = new_data
      parts[0..-2].each do |part|
        raise Chef::Exceptions::WhitelistAttributeNotFound, "Could not find whitelist attribute #{item}." unless all_data[part]

        filtered_data[part] ||= {}
        filtered_data = filtered_data[part]
        all_data = all_data[part]
      end
      raise Chef::Exceptions::WhitelistAttributeNotFound, "Could not find whitelist attribute #{item}" unless all_data[parts[-1]]

      filtered_data[parts[-1]] = all_data[parts[-1]]
      new_data
    end

    def self.to_array(item)
      return item if item.kind_of? Array

      parts = item.split("/")
      parts.shift if !parts.empty? && parts[0].empty?
      parts
    end

  end
end
