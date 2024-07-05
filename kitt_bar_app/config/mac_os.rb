LID_IS_CLOSED = 'ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | head -1 | cut -d"=" -f 2'.freeze

def lid_is_closed?
  `#{LID_IS_CLOSED}`.strip == 'Yes'
end
