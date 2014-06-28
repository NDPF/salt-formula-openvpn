{% from "openvpn/map.jinja" import client with context %}
{%- if client.enabled %}

include:
- openvpn.common

{%- for tunnel_name, tunnel in client.tunnel.iteritems() %}

/etc/openvpn/{{ tunnel_name }}.conf:
  file.managed:
    - source: salt://openvpn/files/client.conf
    - template: jinja
    - default:
      tunnel_name: '{{ tunnel_name }}'
    - require:
      - pkg: openvpn_packages
    - watch_in:
      - service: openvpn_service

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}_{{ tunnel.ssl.certificate }}.crt:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/certs/{{ tunnel.ssl.certificate }}.cert.pem
  - require:
    - file: openvpn_ssl_dir

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}_{{ tunnel.ssl.certificate }}.key:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/certs/{{ tunnel.ssl.certificate }}.key.pem
  - require:
    - file: openvpn_ssl_dir

/etc/openvpn/ssl/{{ tunnel.ssl.authority }}.crt:
  file.managed:
  - source: salt://pki/{{ tunnel.ssl.authority }}/{{ tunnel.ssl.authority }}-chain.cert.pem
  - require:
    - file: openvpn_ssl_dir

{%- endfor %}

{%- endif %}