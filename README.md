# filesystemDemo_ios


- 使用方法
```
git clone 

pod install

然后可以直接run
```

一个简单的文件管理，使用ios沙盒存储文本文件
文件系统Demo开发梳理文档

一、项目功能描述
文件系统管理器，可以对app内沙盒document内文件和文件夹进行系列操作，主页面为文档列表，副页面为简单的个人主页，可以查看收藏
[x] 文件创建，读取（简单文本文稿），修改，收藏，查看信息，复制，移动，重命名，删除等功能
[x] png，jpg，jpeg格式图片的查看
[x] 文件夹的创建，查看信息，复制，移动，重命名，删除等功能
[x] 收藏文件功能
二、实现效果
文件操作
不支持在 Doc 外粘贴 block
文件夹操作
不支持在 Doc 外粘贴 block
查看图片操作
不支持在 Doc 外粘贴 block
收藏操作
不支持在 Doc 外粘贴 block
三、核心技术
- 展示UI
  - 大部分是使用了UITableView，包括文件列表的展示，收藏和相册的入口也是
  - 移动时弹出的选择的MoveView也是使用的一个UITableView，这部分设计到了TableView的insert和remove的操作
//添加ROW，展开文件夹
        //Data
        NSArray *submodels = [didSelectFoldCellModel open];
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
        [self.data insertObjects:submodels atIndexes:indexes];

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

//移除row
 //Data
        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
        [didSelectFoldCellModel closeWithSubmodels:submodels];
        [self.data removeObjectsInArray:submodels];

        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        for (int i = 0; i < submodels.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];



- 文件，文件夹的操作逻辑
  - 文件夹的逻辑操作封装📦在FolderHandle中
    - 文件夹操作函数
+ (BOOL)createFolder:(NSString *)Foldername path:(NSString *)path;//创建
+ (BOOL)copyFolder:(NSString *)foldername;//复制
+ (BOOL)moveFolder:(NSString *)fromPath with:(NSString *)toPath;//移动
+ (BOOL)renameFolder:(NSString *)newName path:(NSString *)foldername;//重命名
+ (BOOL)delectFolder:(NSString *)folderPath;//删除 
    - 大部分逻辑都是需要判断此时该文件夹是否存在，以及移动创建复制路径上有无冲突文件夹
    - 对于复制移动来说，还需要遍历文件夹内的所有文件进行移动操作
//具体循环如下
NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:beforeFolder];
    NSString *path;
    BOOL isSuccess = YES;
    while ((path = [dirEnum nextObject]) != nil) {
        isSuccess = [fm copyItemAtPath:[NSString stringWithFormat:@"%@/%@",beforeFolder,path]
                      toPath:[NSString stringWithFormat:@"%@/%@",afterFolder,path]
                       error:NULL];
    }
         
  - 文件的逻辑操作未进行封装，主要散落在主页面FileListViewController中
  - 具体函数
//创建
- (void)addNewFile;//该函数主要是跳转到TextViewController中，具体实现逻辑位于TextViewController
- (void)saveFile;//需要进行判断是否存在同名文件
//复制，先出数据，在直接创建新文件xxx的副本，直接写入数据
NSData *fileData = [self readFileData:filePath];
            isSuccess = [fm createFileAtPath:toURLStr contents:fileData attributes:nil];
//移动,位于moveView中
- (void)moveFile;
//文件重命名
- (BOOL)reFileName:(NSString *)filePath andtoName:(NSString *)tofilePath;
//删除直接删除即可
 [fm removeItemAtPath:filePath error:&error];
//文件修改 位于TextView逻辑操作中，直接开句柄重写数据即可
NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:nowPath];
[handle writeData:data];
  - 文件的移动，创建，都需判断此时位置是否存在同名文件，否则会导致冲突
- 收藏逻辑
  - 使用sqlite3来进行记录，创建了一个收藏表，并将关于数据库的逻辑操作封装在DBController文件中
  - 具体函数
- (void)createSqlite3DB; //app第一次运行时调用，创建数据库
- (void)createStarTable; //app第一次运行时调用，创建收藏表
- (NSMutableArray *)getStarList; //得到收藏文件列表
- (BOOL)checkisStar:(NSString *)filepath; //检查是否为收藏文件，查看文件时需要初始化文件收藏状态
- (BOOL)addStar:(NSString *)filepath;//添加收藏，逻辑直接把文件路径添加到表里即可
- (BOOL)deleteStar:(NSString *)filepath;//取消收藏

  - 收藏表结构
    - id（主键）int，name （文件路径）text
  - 文件操作时需要添加数据库的操作，以防冲突
    - 文件复制，不需要操作，产生复制文件默认不为收藏文件
    - 文件移动，重命名，需要删除数据库中原始路径，再添加新路径进数据库，保证移动前后收藏状态不变
    - 文件删除，删除数据库中数据即可
- TextViewController
  - 使用UITextView来编辑文件名称和文件内容
  - TextViewController需要区别状态，创建文件状态和读取文件状态，使用isread来标记
  - 创建文件状态，展示空白TextView，文件名称和文件内容均可操作，读取文件状态，文件名称不可操作，文件内容可编辑改变。
  - 文件名称限制字数
//使用函数UITextViewDelegate监听函数


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(textView.tag == 0)   {
        NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
        if (str.length > 50)
        {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
            textView.text = [textView.text substringWithRange:range];
            return NO;
        }
    }
    
    return YES;
}

  - 自主定义UILabel为UITextView添加提示文字,使用监听函数调整是否显示
- (void)textViewDidChange:(UITextView *)textView;//

  - 键盘适应，直接使用IQKeyboardManager，解决键盘收回以及UITextView键盘遮挡问题，UITextVIew输入可随光标滚动
  - 读取文件状态，读取文件内容函数
- (void)readFilea;
- (NSData*)readFileData:(NSString *)path;

- detailView && ImageView && StarView && MyView
  - 这几部分都主要是UI展示的功能，逻辑操作较少
  - detailView文件信息查看，直接使用UITableVIew进行展示
  - ImageView，图片文件查看，直接使用UIImageView即可
  - StarVIew，收藏文件列表，也是使用UITabelVIew，点击cell即可跳转到编辑页面
  - MyView 我的页面，UI展示功能






