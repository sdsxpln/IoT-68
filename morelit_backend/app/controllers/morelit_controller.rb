class MorelitController < ApplicationController

  def history
    output = `sshpass -p 'morelitiot' ssh winet@150.164.10.73 'cat IoT/tp3-grupo1/out'`
    render json: {status: :erro, reason: 'Empty File'} and return if output.nil?

    raw_data = output.split("|")
    render json: {status: :erro, reason: 'Empty File'} and return if raw_data.nil? || raw_data.empty?

    data = []
    raw_data.each do |raw|
      if raw =~ /No de origem: (.*).*Codigo da grandeza: (\d+).*Data: (.*).*Hora: (.*).*Valor: (.*)/
        d = Datum.new
        d.no = $1
        d.grandeza = $2
        d.data =  DateTime.strptime("#{$3.strip} #{$4.strip}", "%m/%d/%Y %R") rescue DateTime.strptime("#{$3.strip} #{$4.strip}", "%d/%m/%Y %R")
        d.valor = $5
        data << d
      end
    end

    render json: {status: :successo, data: data}
  end

  def images
    @endereco = params[:endereco] || ""

    output = `sshpass -p 'morelitiot' scp winet@150.164.10.73:/tmp/#{@endereco}*.jpg #{Rails.root.join('public', 'images')}`
    
    data = []
    files = (Dir.entries Rails.root.join('public', 'images')) - ['..', '.']
    files.each do |file|
      d = Datum.new
      no, grandeza, hora, date = file.gsub('.jpg', '').split("_")

      next unless no == @endereco || @endereco.empty?

      d.no = no
      d.grandeza = grandeza.to_i
      d.data = DateTime.strptime("#{date} #{hora}", "%Y%m%d %H%M%S")
      d.valor = "/images/#{file}"

      data << d
    end

    render json: {status: :successo, data: data}
  end

  def now
    @grandeza = params[:grandeza]
    @endereco = params[:endereco]

    output = `sshpass -p 'morelitiot' ssh winet@150.164.10.73 './IoT/console DATA_COLLECT_REQUEST #{@endereco} #{@grandeza}'`
    render json: {status: :erro, reason: 'Sem Resposta'} and return if output =~ /Sem resposta/i

    d = Datum.new
    if output =~ /No de origem: (.*)\tCodigo da grandeza: (\d+)\tData: (.*)\tHora: (.*)\tValor: (.*)/
      d.no = $1
      d.grandeza = $2
      d.data =  DateTime.strptime("#{$3} #{$4}", "%m/%d/%Y %R")
      d.valor = $5
    end

    render json: {status: :sucesso, data: d}
  end

end
