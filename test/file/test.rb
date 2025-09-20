text = "Twój tekst"

# Zapis do pliku w formacie binarnym
File.open('plik.bin', 'wb') do |file|
  file.write(text.bytes.pack('C*'))
end

