import os
import sys

from rayner_bot.bot import Bot


if __name__ == '__main__':

    for i in ('HOST', 'PORT'):
        if i not in os.environ:
            print('The environment variable %s must be specified' % i)
            sys.exit(1)

    bot = Bot(os.environ['HOST'], os.environ['PORT'])
    bot.client.turn_on()
    bot.run()

    if 'OFF' in os.environ:
        bot.client.turn_off()
