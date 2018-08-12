# sniphpets [![Build Status](https://travis-ci.org/sniphpets/sniphpets.svg?branch=master)](https://travis-ci.org/sniphpets/sniphpets)

This repository contains helper functions for creating php snippets.

## Installation

### Using [pathogen](https://github.com/tpope/vim-pathogen)

```sh
git clone https://github.com/sniphpets/sniphpets ~/.vim/bundle/sniphpets
```

### Using [vundle](https://github.com/gmarik/vundle)

Add to your vimrc:

```vim
Plugin 'sniphpets/sniphpets'
```

### PSR-4 support

This library can't resolve [PSR-4](https://www.php-fig.org/psr/psr-4/) namespaces properly. To solve this issue I would recommend you to install the [phpactor](https://github.com/phpactor/phpactor) plugin. No configuration needed. All should work out of the box.

## License

Copyright (c) Voronkovich Oleg. Distributed under the MIT.
