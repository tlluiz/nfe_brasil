module NfeBrasil
	class SampleData
		DATA = {
			identificacao: {
				nNf: '1',
				naturezaOperacao: 'venda', #Natureza da Operação: venda, compra, transferência, devolução, importação, consignação, remessa
				formaPagamento: '0', #Forma de pagamento: 0 - à vista, 1 - à prazo, 2 - outros
				modelo: '55', #Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
				serie: '1', #Preencher com Zeros caso a NF não possuir série.
				dataEmissao: '2014-02-01', #Data de Emissão da Nota fiscal.
				dataSaidaEntrada: '2014-02-01', #Data de Saída ou Entrada de Mercadoria ou Produto.
				horaSaidaEntrada: '17:24:30', #Hora de Saída da Mercadoria - Formato: HH:MM:SS.
				tipoOperacao: '1', #Tipo de Operação: 0 - Entrada, 1 - Saída.
				tipoImpressao: '1', #Formato de Impressão do DANFE: 1 - retrato, 2 - paisagem
				tipoEmissao: '1', #Tipo de Emissão: 1 - Normal, 2 - Contingência FS, 3 - Contingência SCAN...
				ambienteTransmissao: '2', #Ambiente e transmissão: 1 - Produção, 2 - Homologação
				finalidade: '1', #Finalidade de emissão da NF-e: 1 - NFe Normal, 2 - Nfe Complementar, 3 - Nfe de ajuste
				processoEmissao: '0' #Processo de Emissão da Nf-e: 0 - Aplicativo do Contrinuinte, 1 - Pelo fisco, 2 - Aplicativo de Fisco
			},
			emitente: {
				cnpj: '01999999000199', #CNPJ da empresa emissora da NF.
				razaoSocial: 'Razão social LTDA', #Razão social da Empresa Emissora.
				nomeFantasia: 'Nome Fantasia', #Noma fantasia da empresa emissora da NF.
				endereco: {
					logradouro: 'Rua Das couves',
					numero: '123',
					complemento: 'Fundos',
					bairro: 'Jardom das Hortaliças',
					codigoMunicipio: '3549805', #Código de São José do Rio Preto
					municipio: 'São José do Rio Preto',
					codigoUF: '35',
					uf: 'SP',
					cep: '15000000',
					codigoPais: '1058', #Código BACEN do Brasil
					pais: 'Brasil',
					fone: '1732323232'
				},
				ie: 'ISENTO',
				crt: '1'
			},
			destinatario: {
				cnpj: '12345678000199',
				cpf: '',
				razaoSocial: 'Razão Social o Nome do Destinatário',
				endereco: {
					logradouro: 'Rua COuves Segunda',
					numero: '1234',
					complemento: 'Frente',
					bairro: 'Jardim Horta',
					codigoMunicipio: '3549805',
					municipio: 'São José do Rio Preto',
					uf: 'SP',
					cep: '15000000',
					codigoPais: '1058',
					pais: 'Brasil',
					fone: '1732323232'
				},
				ie: 'ISENTO',
				inscricaoSuframa: '',
				email: 'email@email.com'
			},
			detalhes: {
				det1: {
					produto: { #Informações sobre o produto ou serviço.
						cProd: "3", #Código do Produto ou Serviço - Preencher com CFOP caso se trate de itens não relacionados a mercadoria ou produtos e que o contribuinte não possua numeração própria ex: 'CFOP9999'
						xProd: "Pé de Alface",
						NCM: "07051100",
						CFOP: "5102", #Código CFOP: 5102 - Venda de mercadorias adquirida ou recebida de terceiros.
						uCom: "Unit", #Unidade Comercial.
						qCom: "1", #Quantidade Comercial.
						vUnCom: "30.00", #Valor Unitário de Comercialização - Meramente informativo.
						vProd: "30.00", #Valor total dos produtos.
						uTrib: "Unit", #Unidade Tributável.
						qTrib: "1", #Quantidade tributável - informar a quantidade de tributação do produto.
						vUnTrib: "0", #Valor unitário de tributação.
						indTot: "1" #Indica se o campo vProd desse item compõe o valor total da nota: 0 - Não compõe, 1 - Compõe.
					},
					imposto: { #Informações sobre os impostos incidentes nesse produto
						#TODO - Fazer o detalhamento dos nós de imposto de cada produto ou serviço que compõe a nota.
						ICMS: { #Informações sobre o Importo sobre Circulação de Mercadoria
							ICMSSN102: { #Tributação de ICMS Isenta.
								orig: "0", #Origem da Mercadoria: 0 - Nacional, 1 - Importação.
								CSOSN: "400" #Tributação do ICMS: 400 - Não tributada pelo simples naciona.
							}
						},
						IPI: { #Informações sobre o IPI.
							cEnq: "0", #Código do Enquadramento do IPI. Informar: 0.
							IPINT: { #IPI não tributado.
								CST: "52" #Código da situação tributária do IPI: 52 - Saída Isenta.
							}
						},
						PIS: { #Informações sobre o PIS.
							PISNT: { #PIS Não tributado.
								CST: "07" #Código da situação tributária do PIS: 07 - Operação isenta da contribuição.
							}
						},
						COFINS: { #Informações sobre o COFINS.
							COFINSNT: { #COFINS não tributado.
								CST: "07" #Código da situação tributária do COFINS: 07 - Operação isenta da contribuição.
							}
						}
					}
				}
			},
			total: {
				ICMSTot: {
					vBC: "0.00", #Valor utilizado para base de cálculo do ICMS.
					vICMS: "0.00", #Valor total do ICMS.
					vBCST: "0.00", #Valor utilizado para base de cálculo de ICMS com subsutuição tributária.
					vST: "0.00", #Valor total do ICMS com substuição tributária.
					vProd: "30.00", #Valor total de produtos e serviços.
					vFrete: "0.00", #Valor do frete.
					vSeg: "0.00", #Valor total do seguro.
					vDesc: "0.00", #Valor total de desconto.
					vII: "0.00", #Valor total do II.
					vIPI: "0.00", #Valor total do IPI.
					vPIS: "0.00", #Valor total do PIS.
					vCOFINS: "0.00", #Valor total do COFINS.
					vOutro: "0.00", #Valor com outras despesas acessórias.
					vNF: "30.00" #Valor total da NF-e.
				}
			},
			transporte: {
				modFrete: "0", #Modalidade do Frete: 0 - Por conta do emitente, 1 - Por conta do destinatário, 2 - Por conta de terceiro, 9 - Sem frete.
				transporta: { #Informações da transportadora.
					#Escolha entre um dos dois campos abaixo.
					cnpj: "12345678000101", #CNPJ da empresa transportadora.
					cpf: "", #CPF do transportador.
					razaoSocial: "Razão Social ou Nome Completo do Transportador", #Razão Social ou Nome Completo do Transportador.
					ie: "123456789", #Inscrição Estadual do Transportador.
					endereco: "Rua Nove Horas, 1234, Jardim Relógio", #Endereço completo.
					municipio: "Pontualidade", #Nome do município.
					uf: "SP" #Sigla do estado. Deve ser informado caso o nó IE seja preenchido.
				},
				volumes: { #Informações de Volumes a serem transportados.
					quantidade: "1", #Quantidade de volumes.
					especie: "Caixa", #Espécie de volumes transportados.
					pesoLiquido: "5.000", #Peso Líquido em Kg.
					pesoBruto: "5.500" #Peso Bruto em Kg.
				}
			},
			cobranca: {
				fatura: { #Informações de faturamento.
					nFat: "12345", #Número da Fatura.
					vOrig: "30.00", #Valor Original da Fatura.
					# xml.vDesc "0.00" #Valor de Desconto.
					vLiq: "30.00", #Valor líquido da fatura.
				}
			},
			infoAdicional: {
				infAdFisco: "Olá!", #Informações adicionais de interesse do fisco.
				infCpl: "Essa empresa é optante pelo Simples Nacional." #Informações adicionais de interesse do contribuinte.


			}
		}
	end
end