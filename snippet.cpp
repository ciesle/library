#include<bits/stdc++.h>
using namespace std;
signed main(int argv, char* argc[]){
    string pref,desc,buf;
    vector<string>code;
    if(argv>1){
        ifstream ifs(argc[1]);
        string tmp=argc[1];
        int t=0;
        for(int i=0;i<tmp.size();i++) if(tmp[i]=='/') t=i;
        for(int i=t+1;i<tmp.size()&&tmp[i]!='.';i++) pref+=tmp[i];
        while(getline(ifs,buf)){
            code.push_back(buf);
        }
    }
    else{
        cerr<<"prefix: ";
        getline(cin,pref);
        cerr<<"description: ";
        getline(cin,desc);
        cerr<<"code: \n";
        while(getline(cin,buf)){
            code.push_back(buf);
        }
    }
    for(auto &buf:code){
        string work;
        for(int i=0;i<buf.size();i++){
            if(buf[i]=='/') work+="\\/";
            else if(buf[i]=='\\') work+="\\\\";
            else if(buf[i]=='\"') work+="\\\"";
            else if(buf[i]=='$') work+="\\$";
	    else if(buf[i]=='\t') work+="\\t";
            else work+=buf[i];
        }
        buf="\""+work+"\",";
    }
    cout<<"\t\""<<pref<<"\": {\n";
    cout<<"\t\t\"prefix\" : \""<<pref<<"\",\n";
    cout<<"\t\t\"body\": [\n";
    for(int i=0;i<code.size();i++){
        cout<<"\t\t\t"<<code[i]<<endl;
    }
    cout<<"\t\t],\n";
    cout<<"\t\t\"description\": \""<<desc<<"\",\n";
    cout<<"\t},\n";
}
