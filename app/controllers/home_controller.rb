class HomeController < ApplicationController

	require_relative "Bootrails.rb"

	def index
		@projetos = Projeto.all
		render "index"		
	end

	def create

		diretorio = Bootrails::CriaProjeto.new.gera_diretorio()
		diretorio1 = Bootrails::CriaProjeto.new.diretorio(diretorio)
		diretorio2 = diretorio1+"/"+params[:nome_projeto]	

		pid1 = spawn("cd "+diretorio1+" && "+Bootrails::CriaProjeto.new.projeto(params[:nome_projeto]))
		Process.wait pid1

		Bootrails::CriaProjeto.new.copia_views(diretorio2)
		Bootrails::CriaProjeto.new.copia_template(diretorio2)
		Bootrails::CriaProjeto.new.injeta_js(diretorio2)
		Bootrails::CriaProjeto.new.injeta_css(diretorio2)

		pid2 = spawn("cd "+diretorio2+" && "+Bootrails::CriaProjeto.new.gems()+" && "+Bootrails::CriaProjeto.new.bundle()+
			" && "+Bootrails::CriaProjeto.new.scaffold(params[:nome_entidade], params[:nome_atributo], params[:tipo_dado])+
			" && "+Bootrails::CriaProjeto.new.migrate())
		Process.wait pid2

		Projeto.compactar_projeto(diretorio1)

		porta = Bootrails::CriaProjeto.new.gera_porta().to_s

		@projeto = Projeto.new
		@projeto.nome = params[:nome_projeto]
		@projeto.projeto = diretorio
		@projeto.url = "localhost:#{porta}/"+params[:nome_entidade].downcase+"s"
		@projeto.save

		spawn("cd "+diretorio2+" && "+Bootrails::CriaProjeto.new.servidor(porta))

		redirect_to action: :index 
	end

	def download_projeto
		send_file "#{::Rails.root.join("projetos")}/"+params[:diretorio]+'.zip'
	end

	def destroy
		@projeto = Projeto.find(params[:id])
		@projeto.destroy
		respond_to do |format|
			format.html { redirect_to root_url, notice: 'Projeto was successfully destroyed.' }
			format.json { head :no_content }
		end
	end
end