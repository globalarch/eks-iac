#python3
import sys
import time
import os
from itertools import zip_longest

try:
    import pymongo
except ImportError:
    import ensurepip
    ensurepip.bootstrap()
    os.system('pip3 install pymongo')

from pymongo import MongoClient
from pymongo.read_preferences import Nearest

class Util:
    @staticmethod
    def get_size(obj, seen=None):
        size = sys.getsizeof(obj)
        if seen is None:
            seen = set()
        obj_id = id(obj)
        if obj_id in seen:
            return 0
        seen.add(obj_id)
        if isinstance(obj, dict):
            size += sum([Util.get_size(v, seen) for v in obj.values()])
            size += sum([Util.get_size(k, seen) for k in obj.keys()])
        elif hasattr(obj, '__dict__'):
            size += Util.get_size(obj.__dict__, seen)
        elif hasattr(obj, '__iter__') and not isinstance(obj, (str, bytes, bytearray)):
            size += sum([Util.get_size(i, seen) for i in obj])
        return size


class Benchmark:
    def __init__(self, db, mongo_client: MongoClient, doc_size=100, doc_count=10):
        self.client = mongo_client
        
        '''
        database: test_perf
        collection: doc
        '''
        self.db = self.client[db]
        self.doc_col = self.db.doc
        
        self.DOC_SIZE = doc_size
        self.DOC_COUNT = doc_count
        
        '''
        Flag indicate the comparation in size between string and dict(json object)
        sizeof(Dict) > sizeof(json.dumps(Dict))
            if IS_DICT_COMPARED is True then we compare size of the json in dict form
            else we compare size of the json in binary form (json.dumps(Dict))
        '''
        self.IS_DICT_COMPARED = False
        
    
    # def bin_generator(self, chars=string.ascii_uppercase + string.digits):
    #     return ''.join(random.choice(chars) for _ in range(self.DOC_SIZE)).encode('utf-8')
    
    def doc_generator(self):
        if self.IS_DICT_COMPARED:
            return {"doc":dict(zip_longest(range(self.DOC_SIZE//60), (), fillvalue=1))}
        return json.dumps({"doc":dict(zip_longest(range(self.DOC_SIZE//10), (), fillvalue=1))}).encode('utf-8')
    
    def insert(self):
        '''
        {_id: *
        size: int -> size of doc
        payload: binary/document
        }
        '''
            
        doc_list = [{"size": self.DOC_SIZE, "payload": self.doc_generator()} for _ in range(self.DOC_COUNT)]
        
        t_doc = []
        for d in doc_list:
            start = time.perf_counter()
            self.doc_col.insert_one(d)
            t_doc.append(time.perf_counter()-start)
        return sum(t_doc)/len(t_doc)
    
    def find(self):
        s1 = time.perf_counter()
        self.doc_col.find_one(filter={"size": {"$eq": self.DOC_SIZE}}, limit=self.DOC_COUNT)
        s2 = time.perf_counter()
        return s2-s1
    
    def run(self):
        doc_insert_time = self.insert()
        doc_find_time = self.find()
        
        doc_insert_time,doc_find_time = round(doc_insert_time, 5),round(doc_find_time, 5)
        return {"DOC_SIZE":self.DOC_SIZE, "DOC_COUNT":self.DOC_COUNT, "DOC_INSERT_TIME":doc_insert_time, "DOC_FIND_TIME":doc_find_time}
    
    def test(self):
        self.IS_DICT_COMPARED = True
        doc = self.doc_generator() 
        bin = self.bin_generator()
        print(Util.get_size(doc), Util.get_size(bin))
        
        self.IS_DICT_COMPARED = False
        doc = self.doc_generator() 
        bin = self.bin_generator()
        print(Util.get_size(doc), Util.get_size(bin))
    

if __name__ == '__main__':
    USAGE = 'python3 benchmark.py <MONGODB_IP> <DB_NAME>'
    if len(sys.argv) < 2:
        print(f"[ERROR] INVALID ARGRUMENTS\nUSAGE:\n    {USAGE}")
        exit(1)

    client = MongoClient(host=sys.argv[1], port=27017, readPreference='nearest')
    db = sys.argv[2]
    collect = []
    for doc_size in [10, 50, 100, 1_000, 5_000, 10_000, 50_000, 100_000, 500_000, 1_000_000]: #bytes 
        b = Benchmark(db, client, doc_size=doc_size, doc_count=20)
        result = b.run()
        collect.append(result)
        print(result)
    print("="*20)
    print(collect)
    
    
    
    