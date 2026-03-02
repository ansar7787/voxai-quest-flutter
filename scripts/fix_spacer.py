import os
import glob

# Path to the kids zone games directory
base_dir = r"c:\Users\asus\Documents\App Projects\voxai_quest\lib\features\kids_zone\presentation\pages"

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if "const Spacer()" not in content:
        return

    # Replace Spacer
    content = content.replace("const Spacer(),", "SizedBox(height: 40.h),")

    # Wrap Column with Container and BoxConstraints
    # We find the specific pattern
    target_pattern = """            child: Column(
              children: ["""
              
    replacement = """            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["""
                
    if target_pattern in content:
        content = content.replace(target_pattern, replacement)
        
        # Now we need to add a closing bracket '),' for the Container.
        # It's usually closed like this:
        #             ),
        #           ),
        #         ],
        #       );
        # We can just look for the end of the Padding which wraps the Column.
        # But a simpler way: find the exact closing pattern of the Stack which encapsulates it.
        # In numbers_game_screen it was:
        #                 ],
        #               ),
        #             ),
        #           ],
        #         );
        # Let's replace the ending of the Column.
        end_pattern = """                ],
              ),
            ),
          ],
        );"""
        
        end_replacement = """                ],
              ),
            ),
          ),
        ],
      );"""
      
        if end_pattern in content:
            content = content.replace(end_pattern, end_replacement)
            print(f"Fixed structural issue in {filepath}")
        else:
            print(f"End pattern not found in {filepath}. Used fallback.")
            
    # Also check varying indentations
    target_pattern2 = """              child: Column(
                children: ["""
    replacement2 = """              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["""
    end_pattern2 = """                  ],
                ),
              ),
            ],
          );"""
    end_replacement2 = """                  ],
                ),
              ),
            ),
          ],
        );"""
        
    if target_pattern2 in content:
        content = content.replace(target_pattern2, replacement2)
        if end_pattern2 in content:
            content = content.replace(end_pattern2, end_replacement2)
            print(f"Fixed structural issue in {filepath} (Indent 2)")
            
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# Process all dart files
for filepath in glob.glob(os.path.join(base_dir, "**", "*.dart"), recursive=True):
    fix_file(filepath)
