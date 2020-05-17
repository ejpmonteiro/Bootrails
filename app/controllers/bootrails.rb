module Bootrails

	class CriaProjeto < ::Rails::Generators::Base
		require 'projeto'

		def gera_diretorio
			return diretorio = Time.now.strftime("%d%m%Y%H%M%S%6N")
		end
		
		def diretorio(diretorio)
			tmp_dir = File.join(Dir::home, diretorio)
			Dir.mkdir(tmp_dir)
			return tmp_dir
		end

		def projeto(nome_projeto)
			return "rails new "+nome_projeto
		end

		def alterarDiretorio(nome_projeto)
			return "cd "+nome_projeto
		end

		private def atributo(nome_atributo, tipo_dado)
			tamanho = nome_atributo.length
			atributo = ""
			for i in 0..tamanho-1
				atributo += nome_atributo[i]+":"+tipo_dado[i]+" "
			end		
			return atributo
		end

		def scaffold(nome_entidade, nome_atributo, tipo_dado)
			return "rails g scaffold "+nome_entidade+" "+atributo(nome_atributo, tipo_dado)
		end

		def migrate
			return "rails db:migrate"
		end

		def servidor(porta)
			return "rails server -p #{porta}"
		end
		
		def gems
			#Inserindo as gems na Gemfile
			return "echo gem 'jquery-rails' >> Gemfile && echo gem 'bootstrap' >> Gemfile && echo gem 'font-awesome-rails' >> Gemfile"		
		end

		def bundle
			return "bundle install --gemfile"
		end

		def download_projeto
			send_file "#{::Rails.root.join("projects")}/"+params[:diretorio]+'.zip'
		end

		def gera_porta
			return rand(4000..10000)	
		end

		def copia_views(diretorio)
			FileUtils.cp_r(::Rails.root.join("layouts/templates"), "#{diretorio}/lib");
		end

		def copia_template(diretorio)
			FileUtils.copy_file(::Rails.root.join("layouts/application.html.erb"), "#{diretorio}/app/views/layouts/application.html.erb")
		end

		def injeta_js(diretorio)
			application_js_path = diretorio+'/app/assets/javascripts/application.js'

			if File.exists?(application_js_path)
				inject_into_file application_js_path, before: '//= require rails-ujs' do
					"//= require jquery3
					//= require popper
					//= require bootstrap\n"
				end		
			end
		end

		def injeta_css(diretorio)
			application_css_path = diretorio+'/app/assets/stylesheets/application.css'

			if File.exists?(application_css_path)
				inject_into_file application_css_path, after: '*/' do
					"\n\n@import 'bootstrap'; 
					@import 'font-awesome';"
				end	
				File.rename("#{application_css_path}", "#{diretorio}/app/assets/stylesheets/application.scss")
			end
		end
	end
	
end
