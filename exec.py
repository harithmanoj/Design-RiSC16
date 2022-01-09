
# Python file for compile, simulate and display verilog code.
# Copyright (C) 2022  Harith Manoj

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>. 

import subprocess
import sys

def main(args):

    n = len(args)

    subprocess.call(["iverilog", f'-o single/tb/out/{args[1]}.o single/tb/{args[0]} -I single/'])
    subprocess.call(['vvp', f'single/tb/out/{args[1]}.o'])
    subprocess.call(['gtkwave', f'single/tb/out/{args[1]}.vcd'])


if __name__ == "__main__":
    main(sys.argv)