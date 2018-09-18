import copy
import os
import random
import time

from rayner_bot import client


DEFAULTS = {
    'RUNS_MIN': 5,
    'RUNS_MAX': 15,
    'SLEEP_MIN': 1,
    'SLEEP_MAX': 3,
}

COLORS = (
    'ff0000',
    '00ff00',
    '0000ff',
    '9542f4',
    'f441b8',
    'f49441',
    'f4eb41',
    'b8f441',
    '41f4e2',
)

NAMES = (
    'Clark',
    'Bruce',
    'Diana',
    'Hal',
    'Kyle',
    'John',
    'Barry',
    'Wally',
    'Victor',
    'Oliver',
    'Roy',
    'Jesse',
    'Ronnie',
)


class Bot(object):

    def __init__(self, host, port) -> None:
        super().__init__()
        self.bot_id = random.choice(NAMES) + '-' + client.random_id()
        self.client = client.Client(host, port, client_id=self.bot_id)
        self.config = self._load_config()
        self.print_config()

    def run(self):
        num_runs = random.randint(self.config['RUNS_MIN'], self.config['RUNS_MAX'])
        print('Beginning bot loop for %s iterations' % num_runs)

        for _ in range(num_runs):
            new_color = random.choice(COLORS)
            print('Setting color to: %s' % new_color)
            self.client.change_color_hex(new_color)

            sleep_time = random.randint(self.config['SLEEP_MIN'], self.config['SLEEP_MAX'])
            print('Sleeping for %s before the next change' % sleep_time)
            time.sleep(sleep_time)

    def print_config(self):
        print('Bot Configuration')
        print('  ID: %s' % self.bot_id)
        print('  Service Host: %s' % self.client.host)
        print('  Service Port: %s' % self.client.port)
        for k, v in self.config.items():
            print('  %s: %s' % (k, v))

    @staticmethod
    def _load_config():
        config = copy.copy(DEFAULTS)

        # Attempt to override each default from the environment
        for k in config.keys():
            if k in os.environ:
                config[k] = os.environ[k]

        return config
