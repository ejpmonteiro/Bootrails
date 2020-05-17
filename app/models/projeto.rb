class Projeto < ApplicationRecord

	def self.compactar_projeto(diretorio)
		Zip::File.open(diretorio+'.zip', Zip::File::CREATE) do |arquivo_zip|
			Dir.chdir diretorio
			Dir.glob("**/*").reject { |e| File.directory?(e) }.each do |arquivo|
				puts "Adicionando #{arquivo}"
				arquivo_zip.add(arquivo.sub(diretorio + '/', ''), arquivo)
			end
		end

		copia_projeto(diretorio)
	end

	def self.copia_projeto(diretorio)
		FileUtils.mv(diretorio+".zip", ::Rails.root.join("projetos"))
	end
end