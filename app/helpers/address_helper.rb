module AddressHelper
	def complete_address(address)
    comp_addr = [address.address_line1, address.address_line2, address.city, address.state, address.pincode, address.country].join(',')

    comp_addr = 'https://maps.google.com/?q=' + comp_addr
    comp_addr

  end
end
