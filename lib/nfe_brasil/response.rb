module NfeBrasil
	class Response
		def initialize	
		end

		def envio_nfe(body)
			@envio_nfe = body
		end

		def numero_recibo
			@envio_nfe[:nfe_recepcao_lote2_result][:ret_envi_n_fe][:inf_rec][:n_rec] if @envio_nfe != nil
		end

		def retorno_envio(body)
			@retorno_envio = body
		end

		def protocolo_utilizacao
		end

	end
end