#!/bin/bash

# --- 0. Setup Inicial ---
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip golang curl jq libpcap-dev ruby-full

# Configurar PATH do Go (se não estiver)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc

# --- 1. O Seu Pedido Especial (As 10+ solicitadas) ---
echo "📦 Instalando seu núcleo de ferramentas..."

# Recon & Scanning
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest
sudo apt install -y nikto wpscan whatweb curl

# URL Discovery & Patterns
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/tomnomnom/gf@latest

# Configurando GF (Padrões de busca para XSS, SSRF, etc)
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns
cp Gf-Patterns/*.json ~/.gf/

# --- 2. As +5 Ferramentas de Elite (O diferencial) ---
echo "💎 Adicionando as 5 ferramentas táticas..."

# 1. Katana: O crawler mais rápido da atualidade (melhor que o hakrawler)
go install github.com/projectdiscovery/katana/cmd/katana@latest

# 2. DalFox: Focado 100% em automação de XSS
go install github.com/hahwul/dalfox/v2@latest

# 3. Mantis/S3Scanner: Para caçar exposição em Clouds
pip3 install s3scanner

# 4. Naabu: Scanner de portas ultra-rápido (para não depender só do nmap)
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# 5. Anew: A ferramenta que organiza seu output (evita duplicatas)
go install -v github.com/tomnomnom/anew@latest

# --- 3. Finalização ---
sudo cp ~/go/bin/* /usr/local/bin/
nuclei -ut # Atualiza os templates do Nuclei

echo "🔥 TUDO PRONTO! Seu ambiente está configurado com as 30+ ferramentas mais letais."
