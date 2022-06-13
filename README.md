
## Build tools & versions used
Xcode 11.7 with Swift 5

## Steps to run the app
![alt text](https://github.com/joycytao/Block/blob/master/EmployeeList.png)
![alt text](https://github.com/joycytao/Block/blob/master/EmptyState.png)
![alt text](https://github.com/joycytao/Block/blob/master/Action.png)


## What areas of the app did you focus on?
1. Network Service 
2. ImageDownloader 
3. MVVM + Coordinator 

## What was the reason for your focus? What problems were you trying to solve?
1. Make network layer more resuable, testable and readable. Follow Single Responsibility Principle. 
2. Avoid necessary network calls. 

## How long did you spend on this project?
3-4 hours in the first 3 days. 2 hr in 2 days on comments and README file. 

## Did you make any trade-offs for this project? What would you have done differently with more time?
- Cahce implemetation should have more flexibility. Not only for image but all types of data.
- I only implemented remove all cache for now. But I expect I can evict cache base on the expiry date or size or access count and last access date. I also want to implemented "retry"  if the loading failed. 
- Add security if there is any sensitve file  

- UI can be more prettier. 

## What do you think is the weakest part of your project?
Image Downloader. I proabably miss some scenarios and doesn't have any sercuity design.  Also need to consider if there are large amount of files to download. 


## Did you copy any code or dependencies? Please make sure to attribute them here!
Not really. Take reference from some stack overflow posts but I did modify the code for my implementation. Other part is form project I've worked before. 

## Is there any other information you’d like us to know?
Unit Test coverage rate: 53% 
