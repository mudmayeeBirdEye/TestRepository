# Custom Settings file for Smartsheet application
# Lines beginning with # are comments and ignored

# Web service / site endpoints
webservice.api.url=https://www.smartsheet.com/b/api/salesforce/
web.sso.url=https://www.smartsheet.com/b/sso/salesforce/

# Help pages
help.introduction.url=https://www.smartsheet.com/salesforce-intro
help.main.url=https://www.smartsheet.com/help
help.salesforce.url=https://www.smartsheet.com/help/salesforce

# Sheet Types
#   - Sheet types are containers that can be used as a starting point when creating
#     a sheet from Salesforce.  They must be globally accessible, e.g. in the template
#     gallery, enabled for distribution, or global container types such as "Blank Sheet".
#   - Types are displayed to the user in the order listed here
#   - The format is sequential name-value pairs, e.g. name1,id1,name2,id2,...,nameN,idN
#   - nameN is what the user sees, idN is the containerID 
#   - The first type in the list is the default type when creating a sheet.
#   - If more sheet types are needed than will fit in a setting, add them using sheetTypes.2, sheetTypes.3, etc.
sheetTypes.1=Project with Gantt,2073462,Project - Simple,2073475,Team Task List,2073490,To Do List,2073496,Blank Sheet,2073669
