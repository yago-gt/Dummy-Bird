-- Website: https://yagogt.itch.io/dummy-bird
-- Email: ygtassello@gmail.com
-- Copyright (c) 2019 Yago G. Tassello

require "lib/extend"

virtual_width, virtual_height = 540, 960
VERSION = const({_ = "0.1.15"})
COLOR = const({white = {1, 1, 1, 1}, red = {1, 0, 0, 1}, green = {0, 1, 0, 1}, blue = {0, 0, 1, 1}, transparent = {1, 1, 1, 0}, transparent_black = {0, 0, 0, 0},
               black = {0, 0, 0, 1}, yellow = {1, 1, 0, 1}, cyan = {0, 1, 1, 1}, magenta = {1, 0, 1, 1}})