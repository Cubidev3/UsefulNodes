# UsefulNodes
An Library of Custom Nodes for Godot That I Find Useful

# Features

- Counter
  A integer counter that can count up or down

  ![image](https://github.com/Cubidev3/UsefulNodes/assets/100206395/3aec7721-34ae-4dac-a964-8751395bad1a)

  Set *max* to determine the max value the counter can go.
  Use *count(amount: int)* to change current value and *get_current_count() -> int* to get it.
  Check Percentages with *get_completion_percentage()* -> float and *get_remaining_percentage() -> float*.
  Get Notified when the counter changes, reaches its max or gets zeroed with *changed(difference: int)*, *maxed*, *zeroed* signals.
  
