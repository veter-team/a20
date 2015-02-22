
class BaseView:
    "Interface for all view objects"

    def __init__(self):
        pass
    
    def update_visuals(self):
        pass

    def process_events(self, new_events):
        pass
