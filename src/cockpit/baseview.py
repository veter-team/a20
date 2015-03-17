import Ice


class BaseView:
    "Interface for all view objects"

    def __init__(self):
        pass
    
    def update_visuals(self):
        pass

    def process_events(self, new_events):
        pass

    def get_supported_sensor_types(self):
        """Returns the list of supported sensor types"""
        return []

    def new_data(self, data_type, data):
        """Callback function to receive new data"""
        pass
