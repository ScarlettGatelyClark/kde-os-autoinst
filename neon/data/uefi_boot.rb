#!/usr/bin/env ruby
#
# Copyright (C) 2018 Harald Sitter <sitter@kde.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License or (at your option) version 3 or any later version
# accepted by the membership of KDE e.V. (or its successor approved
# by the membership of KDE e.V.), which shall act as a proxy
# defined in Section 14 of version 3 of the license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# When booting from an ISO os-autoinst messes with nvram so uefi variables seem
# to get lost. To bypass this we'd have to switch on PFLASH which writes into
# the firmware file itself, which also sucks as we'd have to log another file
# around. Instead we simply use UEFI default boot pathing to always let us
# boot as a fallback when no other nvram variables are defined.

# This also implicitly asserts that the EFI directory layout is somewhat sane.

require 'fileutils'

puts "#{$0} Enable uefi default boot."

unless File.exist?('/boot/efi')
  warn "#{$0} system doesn't seem to be UEFI. skipping."
  exit
end

if File.exist?('/boot/efi/EFI/boot')
  FileUtils.rm_r('/boot/efi/EFI/boot', verbose: true)
end

FileUtils.cp_r('/boot/efi/EFI/neon',
               '/boot/efi/EFI/boot',
               verbose: true)

origin = '/boot/efi/EFI/boot/shimx64.efi'
origin = '/boot/efi/EFI/boot/grubx64.efi' unless File.exist?(origin)
FileUtils.cp_r(origin,
               '/boot/efi/EFI/boot/bootx64.efi',
               verbose: true)
