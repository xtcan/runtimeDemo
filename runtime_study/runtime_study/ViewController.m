//
//  ViewController.m
//  runtime_study
//
//  Created by 汤文灿 on 16/6/29.
//  Copyright © 2016年 tcan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "NSObject+obj.h"
#import "UIImage+category.h"
#import "NSObject+model.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *title_array;//标题数组

@end

@implementation ViewController

/**
 *  标题数组
 */
- (NSArray *)title_array{
    
    if (_title_array == nil) {
        
        _title_array = [NSArray arrayWithObjects:
                        @"0.消息传递",
                        @"1.获取类的成员变量",
                        @"2.获取类的所有属性名",
                        @"3.获取类的全部方法",
                        @"4.获取类遵循的全部协议",
                        @"5.动态改变成员变量",
                        @"6.动态交换类方法",
                        @"7.动态添加方法",
                        @"8.动态为Category扩展加属性",
                        @"9.解档归档",
                        @"10.字典转Model",
                        @"11.动态获得类，调用方法",
                        nil];
    }
    return _title_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //交换方法
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    imgView.image = [UIImage imageNamed:@""];
//    [self.view addSubview:imgView];
    
    //设置界面
    [self setupView];
    
}

/**
 *  设置界面
 */
- (void)setupView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return self.title_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString  *cellId = @"runtimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.title_array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    NSLog(@"%@",self.title_array[row]);
    
    switch (row) {
        case 0:
           //@"0.消息传递"
            [self messageSend];
            break;
        case 1:
            //@"1.获取类的成员变量",
            [self getClassIvars];
            break;
        case 2:
            // @"2.获取类的所有属性名",
            [self getClassProperty];
            break;
        case 3:
            //@"3.获取类的全部方法",
            [self getClassMethod];
            break;
        case 4:
            //@"4.获取类遵循的全部协议",
            [self getClassProtocol];
            break;
        case 5:
            //@"5.动态改变成员变量",
            [self changeClassMember];
            break;
        case 6:
            //@"6.动态交换类方法",
            [self ClassExchangeMethod];
            break;
        case 7:
            //@"7.动态添加方法",
            [self CategroryAddMethod];
            break;
        case 8:
            //@"8.动态为Category扩展加属性",
            [self CategroryExtensionProperty];
            break;
        case 9:
            //@"9.解档归档",
            [self archive];
            break;
        case 10:
            //@"10.字典转Model",
            [self dicToModel];
            break;
        case 11:
            //@"11.动态获得类，调用方法",
            [self getDynamic];
            break;
  
        default:
            break;
    }
}

/**
 *  消息传递
 */
- (void)messageSend{
    
    //对象消息传递
    Person *p = [[Person alloc]init];
    objc_msgSend(p, @selector(say:),@"对象消息传递");
    
    //类消息传递
    objc_msgSend([Person class], @selector(say));
}

/**
 *  获取类的成员变量
 */
- (void)getClassIvars{
    
    unsigned int count = 0;
    
    //Ivar *：指向一个成员变量列表
    Ivar *ivarList = class_copyIvarList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"成员变量名称：%@",key);//注：私有成员变量也可获取，例 _job
    }
    
    //释放
    free(ivarList);
}

/**
 *  获取类的所有属性名
 */
- (void)getClassProperty{
    
    unsigned int count = 0;
    
    //获得属性列表指针
    objc_property_t *propertyList = class_copyPropertyList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t temp = propertyList[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(temp)];
        NSLog(@"属性名称：%@",key);
    }
    
    //释放
    free(propertyList);
}

/**
 *  获取类的全部方法
 */
- (void)getClassMethod{
    
    unsigned int count = 0;
    
    //获取方法列表指针
    Method *methodList = class_copyMethodList([Person class], &count);
    
    //遍历
    for (int i = 0; i < count; i++) {
        
        //获得该类的某个方法指针
        Method method = methodList[i];
        
        //获得方法
        SEL methodSEL = method_getName(method);
        
        //方法名
        NSString* methodName = [NSString stringWithUTF8String:sel_getName(methodSEL)];
        
        //获取方法参数个数
        int arguments = method_getNumberOfArguments(method);
        
        NSLog(@"方法名称 : %@ ,参数个数 : %d",methodName,arguments);
    }
    
    //释放内存
    free(methodList);
}

/**
 *  获取类遵循的全部协议
 */
- (void)getClassProtocol{
    
    unsigned int count = 0;
    
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        //遍历得到的一个协议指针
        Protocol *temp_protocol = protocols[i];
        
        //获取协议名称
        NSString *protocolName = [NSString stringWithUTF8String:protocol_getName(temp_protocol)];
        
        NSLog(@"协议名称 : %@",protocolName);
    }
    
    //释放内存
    free(protocols);
}


/**
 *  动态改变成员变量
 */
- (void)changeClassMember{
    
    //初始化一个对象
    Person *person = [[Person alloc] init];
    person.name = @"张三";
    
    NSLog(@"旧名字 : %@",person.name);
    
    
    unsigned int count = 0;
    
    //获得成员变量的数组指针
    Ivar *ivarList = class_copyIvarList([person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar var = ivarList[i];
        
        //根据ivar获得成员变量名称
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        
        //当属性变量为name，改变为李四
        if ([name isEqualToString:@"_name"]) {
            
            //设置变量值
            object_setIvar(person, var, @"李四");
            break;
        }
        
    }
    
    //释放内存
    free(ivarList);
    
    //打印新名字
    NSLog(@"新名字 : %@",person.name);
}


/**
 *  动态交换类方法
 */
- (void)ClassExchangeMethod{
    
    //获得对象
    Person *person1 = [[Person alloc]init];
    
    NSLog(@"交换之前 do something:");
    [person1 doSomething];
    
    NSLog(@"交换之前 doOtherthing:");
    [person1 doOtherthing];
    
    //首先获取Person的2个方法IMP
    Method method_1= class_getInstanceMethod([Person class], @selector(doSomething));
    Method method_2 = class_getInstanceMethod([Person class], @selector(doOtherthing));
    
    //交换方法
    method_exchangeImplementations(method_1, method_2);
    
    NSLog(@"交换之后 do something:");
    [person1 doSomething];
    
    NSLog(@"交换之后 doOtherthing:");
    [person1 doOtherthing];
    
    //注：runtime 修改的是类，下次编译前，都是有效的。
    
    Person *person2 = [[Person alloc]init];
    
    NSLog(@"运行时改变后person2 do something：");
    [person2 doSomething];
    
    NSLog(@"运行时改变后person2 do doSomeOtherThing：");
    [person2 doOtherthing];
    
}


/**
 *  动态添加方法
 */
- (void)CategroryAddMethod{
    
    class_addMethod([Person class], @selector(fromWhere:), (IMP)fromWhereAnswer, "v@:@");
    
    Person *person = [Person new];
    
    if ([person respondsToSelector:@selector(fromWhere:)]) {
        
        [person performSelector:@selector(fromWhere:) withObject:@"广州"];
        
    }else{
        
        NSLog(@"无法告诉你我从哪里来");
    }
}

/**
 *  动态添加的方法实现
 */
void fromWhereAnswer(id self, SEL _cmd, NSString *str){
    
    NSLog(@"我来自:%@",str);
}



/**
 *  动态为Category添加属性
 */
- (void)CategroryExtensionProperty{
    /*
     Category提供了一种比继承（inheritance）更为简洁的方法来对class进行扩展，无需创建对象类的子类就能为现有的类添加新方法，可以为任何已经存在的class添加方法，包括哪些没有源代码的类（如某些框架类）。
     
     类别的局限性
     （1）无法向类中添加新的实例变量，类别没有位置容纳实例变量。
     （2）名称冲突，即当类别中的方法与原生类方法名称冲突时，类别具有更高的优先级。类别方法将完全取代初始方法从而无法再使用初始方法。
     
     */
    
    //通过runtime 可以让category添加属性
    
    //分类动态添加属性
    NSObject *obj = [[NSObject alloc]init];
    obj.name = @"lalala";
    NSLog(@"动态添加的属性name，值为:%@",obj.name);
}

/**
 *  解档归档
 */
- (void)archive{
    
    //获得对象
    Person *person = [[Person alloc] init];
    person.name = @"xixixi";
    person.age = 23;
    
    //对象写到文件
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/archive2",docPath];
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    
    //解档对象
    Person *unarchiverPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"unarchiverPerson: %@",unarchiverPerson);
    
}

/**
 *  字典转换model
 */
- (void)dicToModel{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"xixixi",@"name",
                          @"23",@"age",
                          nil];
    //字典转模型
    Person *person = [Person modelWithDict:dict];
    NSLog(@"字典转模型：%@",person);
}

/**
 *  动态获得类，调用方法
 */
- (void)getDynamic{
    
    //获得类名
    Class personClass = NSClassFromString(@"Person");
    
    //获得方法
    SEL method = NSSelectorFromString(@"getPerson");
    
    //获得对象
    id person = objc_msgSend(personClass, method);
    
    //打印
    NSLog(@"person : %@",person);
    
    //获得方法名称
    SEL doSomething = NSSelectorFromString(@"doSomething");
    
    objc_msgSend(person,doSomething);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
