module NfeBrasil
	#Classe responsável por gerar a chave de acesso da Nota Fiscal Eletrônica.
	class NfeAccessKey
		DATA = {
			cnpj: '', #CNPJ do Emitente da Nota Fiscal Eletrônica.
			cUF: '', #Código da Unidade Federativa do Emitente de acordo com a Tabela do IBGE.
			nNf: '' #Número da Nota Fiscal.
		}

		def initialize(data)
			@data = DATA.merge(data)
			@accessKey = ""
			@randomCode = ""
			@ponderacao = ""
			generate_access_key
		end

		def data
			@data
		end

		def accessKey
			@accessKey
		end

		def randomCode
			@randomCode
		end

		def digitoVerificador
			@digitoVerificador
		end

		# TODO: <%= barcode '35111206276736000173550020000025001000172050', :encoding_format => Gbarcode::BARCODE_128C %>
		def generate_access_key
			@accessKey = @data[:cUF]
			@accessKey += (Date.today.year - 2000).to_s
			@accessKey += Date.today.strftime("%m")
			@accessKey += @data[:cnpj]
			@accessKey += "55"
			@accessKey += "001"
			@accessKey += format("%09i", @data[:nNf])
			@accessKey += "1"
			@accessKey += random_code_generate
			ponderacao_generate
			if @ponderacao == 1 || @ponderacao == 0
				@digitoVerificador = "0"
				@accessKey += @digitoVerificador
			else
				@digitoVerificador = (11 - @ponderacao).to_s
				@accessKey += @digitoVerificador
			end
		end
  
		def ponderacao_generate
			key = @accessKey.split(//)
			count = key.count - 1
			ponderacao = Array.new
			peso = 2
			while count >= 0 do
				ponderacao << key[count].to_i * peso
				if peso < 9
					peso += 1
				else
					peso = 2
				end
				count -= 1
			end
			somatorio = 0
			ponderacao.each do |p|
				somatorio += p
			end
			@ponderacao = somatorio % 11
		end
  
		def random_code_generate
			code = String.new
			8.times do
				code += SecureRandom.random_number(10).to_s
			end
			# @randomCode = code
			@randomCode = "19283746"
		end

	end
end