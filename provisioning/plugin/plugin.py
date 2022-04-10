def host2dict(host_string, priority = 1):
    print({
        "host": host_string,
        "priority": priority
    })
    return {
        "host": host_string,
        "priority": priority
    }
class FilterModule(object):
    ''' Ansible dict filters '''

    def filters(self):
        return {
            'host2dict': host2dict,
        }
