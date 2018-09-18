import random
import requests
import string


class Client(object):

    def __init__(self, host, port, client_id=None) -> None:
        self.host = host
        self.port = port
        self.client_id = client_id or random_id()

    def turn_on(self):
        requests.post(self.url)

    def turn_off(self):
        requests.delete(self.url)

    def change_color_hex(self, hex):
        body = {
            'hex': hex,
            'client_id': self.client_id
        }
        requests.put(self.url, data=body)

    @property
    def url(self):
        return 'http://%s:%s/light/' % (self.host, self.port)


def random_id():
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(6))
