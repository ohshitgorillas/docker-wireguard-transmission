import os
import subprocess
import shutil
import re

# Return ping latency in ms
def ping(host):
    ping_response = subprocess.run(['ping', '-c', '3', '-w', '1000', host], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = ping_response.stdout.decode('utf-8')
    if 'time=' not in output:
        return float('inf')
    else:
        match = re.search(r'(\d+\.\d+)/\d+\.\d+/\d+\.\d+/\d+\.\d+', output)
        if match:
            return float(match.group(1))
        else:
            return float('inf')


# Find all WireGuard config files in /etc/wireguard
def get_fastest_server():
    configs = subprocess.check_output(["find", "/etc/wireguard/", "-name", "*.conf"]).decode().split()
    fastest_server = None
    fastest_ping_time = float('inf')
    fastest_config_file = None

    # iterate through each config file to extract and ping the endpoint
    for config_file in configs:
        with open(config_file, 'r') as f:
            lines = f.readlines()
            # Extract the endpoint from the config file
            endpoint = [line for line in lines if 'Endpoint' in line][0].strip().split('=')[1].strip()
            ip_address, port = endpoint.split(':')
            # Get the ping time
            ping_time = ping(ip_address)
            # update fastest_server variables
            if ping_time < fastest_ping_time:
                fastest_ping_time = ping_time
                fastest_server = config_file[:-5]  # remove .conf extension
                fastest_config_file = config_file

    # check if the fastest config file is not already /etc/wireguard/wg0.conf
    if fastest_config_file != "/etc/wireguard/wg0.conf":
        # copy the fastest server file to /etc/wireguard/wg0.conf
        shutil.copy(fastest_config_file, "/etc/wireguard/wg0.conf")

    # return the name and ping time of the fastest server and the name of the original config file
    return fastest_server, fastest_ping_time, fastest_config_file


def main():
    fastest_server = get_fastest_server()
    print(f'Fastest server: {fastest_server[0]} | Ping: {fastest_server[1]:.2f} ms | Original config file: {fastest_server[2]}')


if __name__ == '__main__':
    main()
