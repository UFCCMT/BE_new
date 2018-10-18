-----------------------------------------------------------------------------------------------------
-- ceillog:
-- Description:
-- Implements ceil of log to the base2 function to round the answer to the nearest integer. 
-- Usage: clog2(value)
-----------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;


package ceillog is

function clog2(input : positive) return positive;

end package;

package body ceillog is

  function clog2(input : positive) return positive is
    variable temp      : natural;
    variable logVal    : natural;
  begin
    -- handle special 1 case
    if (input = 1) then
      return 1;
    end if;

    temp     := input - 1;
    logVal   := 0;
    while (temp /= 0) loop
      temp   := temp / 2;
      logVal := logVal + 1;
    end loop;

    return logVal;
  end function;
  
end package body;