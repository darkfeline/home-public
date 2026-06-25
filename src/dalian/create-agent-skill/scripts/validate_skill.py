#!/usr/bin/env python3
import sys
import os
import re

def print_err(msg):
    print(f"Error: {msg}", file=sys.stderr)

def print_warn(msg):
    print(f"Warning: {msg}", file=sys.stderr)

def parse_frontmatter(content):
    lines = content.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, "SKILL.md must start with '---'"
    
    end_idx = -1
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_idx = i
            break
            
    if end_idx == -1:
        return None, "SKILL.md must have a closing '---' for frontmatter"
        
    frontmatter_lines = lines[1:end_idx]
    body_lines = lines[end_idx+1:]
    
    # Parse simple YAML key-value pairs
    yaml_data = {}
    current_key = None
    in_metadata = False
    metadata_indent = -1
    
    for line in frontmatter_lines:
        if not line.strip() or line.strip().startswith("#"):
            continue
            
        # Detect metadata block (indented key-value mapping)
        indent = len(line) - len(line.lstrip())
        
        if in_metadata:
            if indent > metadata_indent:
                match = re.match(r"\s*([a-zA-Z0-9_-]+)\s*:\s*(.*)", line)
                if match:
                    k, v = match.groups()
                    yaml_data["metadata"][k] = v.strip().strip('"').strip("'")
                    continue
            else:
                in_metadata = False
                
        match = re.match(r"\s*([a-zA-Z0-9_-]+)\s*:\s*(.*)", line)
        if match:
            k, v = match.groups()
            v_val = v.strip().strip('"').strip("'")
            if k == "metadata":
                in_metadata = True
                metadata_indent = indent
                yaml_data["metadata"] = {}
            else:
                yaml_data[k] = v_val
                
    return yaml_data, body_lines

def validate_skill(skill_dir):
    skill_dir = os.path.abspath(skill_dir)
    skill_md_path = os.path.join(skill_dir, "SKILL.md")
    
    if not os.path.exists(skill_md_path):
        print_err(f"SKILL.md not found in {skill_dir}")
        return False
        
    with open(skill_md_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    yaml_data, body_or_err = parse_frontmatter(content)
    if yaml_data is None:
        print_err(body_or_err)
        return False
        
    success = True
    
    # Validate name
    name = yaml_data.get("name")
    if not name:
        print_err("Missing required field 'name'")
        success = False
    else:
        if len(name) > 64:
            print_err(f"Name '{name}' exceeds 64 characters limit (length: {len(name)})")
            success = False
        if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", name):
            print_err(f"Name '{name}' is invalid. Must contain only lowercase letters, numbers, and single hyphens. Cannot start or end with a hyphen.")
            success = False
        
        dir_name = os.path.basename(skill_dir)
        if name != dir_name:
            print_err(f"Skill name '{name}' must match parent directory name '{dir_name}'")
            success = False
            
    # Validate description
    description = yaml_data.get("description")
    if not description:
        print_err("Missing required field 'description'")
        success = False
    else:
        if len(description) > 1024:
            print_err(f"Description exceeds 1024 characters limit (length: {len(description)})")
            success = False
            
    # Validate compatibility
    compatibility = yaml_data.get("compatibility")
    if compatibility and len(compatibility) > 500:
        print_err(f"Compatibility exceeds 500 characters limit (length: {len(compatibility)})")
        success = False
        
    # Warn about body line count
    body_lines = body_or_err
    if len(body_lines) > 500:
        print_warn(f"SKILL.md body has {len(body_lines)} lines, which exceeds the recommended limit of 500 lines. Consider moving detailed references to references/ directory.")
        
    # Check for relative path existence in the body
    # Find markdown links: [text](path)
    links = re.findall(r"\[[^\]]+\]\(([^)]+)\)", "\n".join(body_lines))
    for link in links:
        # Ignore external links, anchors, and absolute paths
        if link.startswith("http://") or link.startswith("https://") or link.startswith("#") or link.startswith("/"):
            continue
        # Clean up query params or anchors from link path
        link_path = link.split("#")[0].split("?")[0]
        if not link_path:
            continue
        full_link_path = os.path.join(skill_dir, link_path)
        if not os.path.exists(full_link_path):
            print_warn(f"Referenced path '{link_path}' does not exist relative to skill root")
            
    if success:
        print(f"✓ Skill '{name}' is valid!")
    return success

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 validate_skill.py <path_to_skill_directory>")
        sys.exit(1)
        
    target_dir = sys.argv[1]
    if not os.path.isdir(target_dir):
        print_err(f"'{target_dir}' is not a directory")
        sys.exit(1)
        
    valid = validate_skill(target_dir)
    sys.exit(0 if valid else 1)
