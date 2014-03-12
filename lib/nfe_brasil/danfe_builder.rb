require 'prawn'

module NfeBrasil
	class DanfeBuilder < Prawn::Document
		def initialize
			super
			text "Olá tudo bem?"
			
		end
	end
end