[theme] 
theme = "native"

[icons]
icons = "awesome4"

[[block]]
block = "custom"
command = ''' curl https://wttr.in?format=1 '''
interval=3600
[[block.click]]
button = "left"
cmd = ''' kitty --class "kitty_floating" --title "Weather report as of $(date)" bash -c "echo -e 'Weather Report - Press ENTER to close\n' ; curl https://wttr.in?F; read" '''

[[block]]
block = "custom"
command = ''' BLOCK_INSTANCE=tron echo "\$$(curl -sSL https://cryptoprices.cc/TRX)" '''
interval=900
[[block.click]]
button = "left"
cmd = "firefox https://coinmarketcap.com/currencies/tron/"

[[block]]
block = "custom"
command = ''' BLOCK_INSTANCE=bitcoin echo "\$$(curl https://cryptoprices.cc/BTC)" '''
interval=900
[[block.click]]
button = "left"
cmd = "firefox https://coinmarketcap.com/currencies/bitcoin/"

