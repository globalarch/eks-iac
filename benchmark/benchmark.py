#python3
import sys
import time

try:
    from pymongo import MongoClient
except ImportError:
    print('''pymongo not exist, please install
                pip3 install pymongo
          ''')
    exit(1234)

class StupidLog:
    def __init__(self, enabled):
        self.enabled = enabled
        
    def log(self, msg, force_flag=None):
        if force_flag is not None:
            if force_flag:
                print(msg)
            return
        if self.enabled:
            print(msg)
        
class Benchmark:
    def __init__(self, db, mongo_client: MongoClient, log: StupidLog, doc_size=100, doc_count=10, insert_region=None, find_region=None):
        self.client = mongo_client
        self.db = self.client[db]
        self.doc_col = self.db.doc
        self.logger = log
        
        self.DOC_SIZE = doc_size
        self.DOC_COUNT = doc_count
        self.insert_region = insert_region
        self.find_region = find_region

        self.ENABLE_LOG = False

    
    def doc_generator(self):
        return {"doc":dict([("0",1) for _ in range(self.DOC_SIZE//60)])}

    def insert(self):
        region = self.insert_region
        '''
        {
            _id: *
            size: int -> size of doc
            payload: document
        }
        '''
        
        base_doc_list = [
            {
                "size": self.DOC_SIZE, 
                "payload": self.doc_generator()
             } for _ in range(self.DOC_COUNT)
        ]
        
        if region is not None:
            for x in base_doc_list:
                x['ga_region'] = region
        
        doc_list = base_doc_list
        self.logger.log(f"Inserting... {region = }, {doc_list = }", False)

        t_doc = []
        for d in doc_list:
            start = time.perf_counter()
            self.doc_col.insert_one(d)
            t_doc.append(time.perf_counter()-start)
        return sum(t_doc)/len(t_doc)
    
    def find(self):
        region = self.find_region
        
        self.logger.log(f"Finding with {region = }....")
        if region is None:
            doc_list = self.doc_col.find(filter={"size": {"$eq": self.DOC_SIZE}}, limit=self.DOC_COUNT)
        else:
            self.logger.log(f"Finding {{'ga_region': {region}}}")
            doc_list = self.doc_col.find(filter={"size": {"$eq": self.DOC_SIZE}, "ga_region": region}, limit=self.DOC_COUNT)
        
        t_doc = []
        for doc in doc_list:
            s1 = time.perf_counter()
            if region is None:
                self.doc_col.find_one(filter={"size": {"$eq": self.DOC_SIZE}})
            else:
                self.logger.log({"_id": doc['_id'], "ga_region": region})
                self.doc_col.find_one(filter={"_id": doc['_id'], "ga_region": region})
            t_doc.append(time.perf_counter() - s1)
            
        return sum(t_doc)/len(t_doc)

    
    def run(self):
        doc_insert_time = self.insert()
        doc_find_time = self.find()
        
        doc_insert_time,doc_find_time = round(doc_insert_time, 5),round(doc_find_time, 5)
        return {"DOC_SIZE":self.DOC_SIZE, "DOC_COUNT":self.DOC_COUNT, "DOC_INSERT_TIME":doc_insert_time, "DOC_FIND_TIME":doc_find_time, "REGION": self.insert_region}
    

if __name__ == '__main__':
    USAGE = 'python3 benchmark.py <MONGODB_IP> <DB_NAME> <REGION>'
    if len(sys.argv) < 4:
        print(f"[ERROR] INVALID ARGRUMENTS\nUSAGE:\n    {USAGE}")
        exit(1)

    client = MongoClient(host=sys.argv[1], port=27017, readPreference='nearest')
    db = sys.argv[2]
    region = sys.argv[3]
    if region.lower() in ['none', 'null']:
        region = None
    collect = []
    for doc_size in [100, 1_000, 5_000, 10_000]: #bytes 
        b = Benchmark(db, client, StupidLog(True), 
                      doc_size=doc_size, 
                      doc_count=20, 
                      insert_region=region,
                      find_region=region
                      )
        result = b.run()
        collect.append(result)
        print(result)
    print("="*20)
    print(collect)
    
    
    
    