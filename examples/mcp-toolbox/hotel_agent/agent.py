import os
from datetime import date

from google.adk.agents.llm_agent import LlmAgent
from toolbox_core import ToolboxSyncClient

#-------------------
# settings
#-------------------
model="gemini-2.5-flash"

toolbox = ToolboxSyncClient("http://127.0.0.1:7000")
hotel_db_tools = toolbox.load_toolset("hotel_toolset")


#-----------------
# agents
#-----------------
hotel_agent = LlmAgent(
    name="hotel_agent",
    model=model,
    description=(
        "Agent to answer questions about hotels in a city or hotels by name."
    ),
    instruction=(
        "You are a helpful agent who can answer user questions about the hotels in a specific city or hotels by name. Use the tools to answer the question"
    ),
    tools=hotel_db_tools,
)


root_agent = hotel_agent
