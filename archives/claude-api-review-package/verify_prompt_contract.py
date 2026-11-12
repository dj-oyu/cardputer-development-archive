"""Run from the feature checkout; no network, credentials or runtime imports."""
import ast
import subprocess
from pathlib import Path

BASE = "b93459d26d208c40527b13b6cdfaecb1f0586179"

def contract(source):
    tree = ast.parse(source)
    functions = {node.name: node for node in tree.body if isinstance(node, ast.FunctionDef)}
    prepare = ast.dump(functions["prepare_messages_for_api"], include_attributes=False)
    tools = next(node.value for node in ast.walk(functions["get_ai_response"])
                 if isinstance(node, ast.Assign)
                 and any(isinstance(target, ast.Name) and target.id == "tools" for target in node.targets))
    return prepare, ast.literal_eval(tools)

before = subprocess.check_output(["git", "show", BASE + ":lambda/ai_processor.py"]).decode("utf-8")
after = Path("lambda/ai_processor.py").read_text(encoding="utf-8")
assert contract(before) == contract(after), "Prompt, history preparation or tool schema changed"
print("Production prompt, history preparation and search schema exactly match the base main")
