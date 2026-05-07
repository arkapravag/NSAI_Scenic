These Scenic files were regenerated to avoid invalid combinations of position specifiers.

Why the previous syntax failed:
- Scenic raises an ambiguity error when two specifiers both assign `position` at priority 1.
- Example of invalid pattern:
  `new Car behind ego by 24, offset by 3 @ 0`
- `behind ...` specifies position with priority 1.
- `offset by ...` also specifies position with priority 1.
- Result: `SpecifierError: property "position" specified twice with the same priority`

Documentation basis:
- Scenic Specifiers Reference: multiple priority-1 position specifiers are ambiguous.
- `offset along direction by vector` is a single position specifier and is safe for relative placement.

Regeneration choices:
- Used the user's updated base scene path: ../../maps/Town01.xodr
- Kept the pedestrian crossing logic
- Kept the ego as a separate behavior and set it to brake/avoid within 10 units:
  `DriveAvoidingCollisions(target_speed=20, avoidance_threshold=10)`
- Replaced ambiguous relative placements with:
  `offset along ego.orientation by X @ Y`
