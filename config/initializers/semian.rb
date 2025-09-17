require "semian"
require "semian/net_http"

# Registrar o recurso :g1_scraper com as opções desejadas
Semian.register(
  :g1_scraper,
  tickets: 2,
  timeout: 5,
  error_threshold: 3,
  error_timeout: 10,
  success_threshold: 1
)
