import os

stringModel = """
<infomation>
<offset={0};byte={1};index={2};IsCombined=False>
==========================
<ENGLISH>
==========================
{3}
==========================
<CHINESE>
==========================
{3}
==========================
"""
IsCombined = False
IsNextCombined = False

def CombinedText():
    """将前一个字符串多余的字节转移给下一个字符串"""
    global IsCombined
    global IsNextCombined
    first_offset = offset
    first_byte = byte
    first_index = index
    BinFile.seek(first_byte + first_offset)
    code_bytes = b''
    if (BinFile.read(1) != b'"'):
        IsCombined = False
        print(f"错误：Episode{i:02}.bin 合并index={index}失败\n提示：请使用原始文件操作")
        return
    
    while (TextFile.readline() != "<CHINESE>\n"):
        continue
    TextFile.readline()
    first_string = TextFile.readline().replace("\n","")
    #print(first_string,first_offset,first_byte)

    while (TextFile.readline() != "<infomation>\n"):
        continue
    exec(TextFile.readline().replace("\n","").replace("<","").replace(">",""),globals())
    second_offset = offset
    second_byte = byte
    while (TextFile.readline() != "<CHINESE>\n"):
        continue
    TextFile.readline()
    second_string = TextFile.readline().replace("\n","")
    #print(second_string,second_offset,second_byte)

    code_byte_len = second_offset - (first_offset + first_byte)
    code_bytes += first_string.encode("GBK")
    space_len = first_byte - len(code_bytes)
    BinFile.seek(first_byte + first_offset)
    for i in range(code_byte_len):
        code_bytes += BinFile.read(1)
    space_len += second_byte - len(second_string.encode("GBK"))
    code_bytes += second_string.encode("GBK")

    while (IsNextCombined):
        IsNextCombined = False
        last_offset = offset
        last_byte = byte
        while (TextFile.readline() != "<infomation>\n"):
            continue
        exec(TextFile.readline().replace("\n","").replace("<","").replace(">",""),globals())
        this_offset = offset
        this_byte = byte
        while (TextFile.readline() != "<CHINESE>\n"):
            continue
        TextFile.readline()
        this_string = TextFile.readline().replace("\n","")
        code_byte_len = this_offset - last_offset - last_byte
        space_len += this_byte - len(this_string.encode("GBK"))
        BinFile.seek(last_offset + last_byte)
        for i in range(code_byte_len):
            code_bytes += BinFile.read(1)
        code_bytes += this_string.encode("GBK")

    for i in range(space_len):
        code_bytes += b'\x20'
    BinFile.seek(first_offset)
    BinFile.write(code_bytes)
    BinFile.flush()
    code_bytes = b''
    #print(f"成功合并：Episode{i:02}.bin index={first_index}处若干")
    IsCombined = False

def Text2Bin(first,last):
    """将16个bin文件以及对应的txt文件与本脚本放在同一目录中
    参数为range函数的起始终止值"""
    offset = -1
    byte = 0
    index = 0
    for i in range(first,last):
        TextFile = open(f"Episode{i:02}.bin.txt",'r',encoding="gbk")
        BinFile = open(f"Episode{i:02}.bin",'rb+')
        while True:
            Read = TextFile.readline()
            if Read == "<infomation>\n":
                code = TextFile.readline()
                exec(code.replace("\n","").replace("<","").replace(">",""),globals())
                if IsCombined:
                    CombinedText()
                    continue
                while (TextFile.readline() != "<CHINESE>\n"):
                    continue
                TextFile.readline()
                CHSText = TextFile.readline().replace("\n","")
                CHSByte = CHSText.encode("GBK")
                if len(CHSByte) > byte:
                    print(f"Episode{i:02}.bin：无法打包index={index}处文本\n原因：中文字节数多于英文字节数")
                    continue
                for x in range(byte-len(CHSByte)):
                    CHSByte += " ".encode("GBK")
                BinFile.seek(offset)
                BinFile.write(CHSByte)
                #print(f"成功：Episode{i:02}.bin index={index}")
            if Read == "":
                break
        TextFile.close()
        BinFile.flush()
        BinFile.close()

def Bin2Text(first,last):
    """将16个bin文件与本脚本放在同一目录中
    参数为range函数的起始终止值"""
    global stringModel
    offset = -1
    byte = b''
    lastbyte = b''
    EnglishStr = []
    index = 0
    loop = False
    for i in range(first,last):
        offset = -1
        index = 0
        byte = lastbyte = b''
        EnglishStr = []
        InFile = open(f"Episode{i:02}.bin",'rb')
        OutFile = open(f"Episode{i:02}.bin.txt",'w',encoding="GBK")
        OutFile.write(f"""/*<Episode{i:02}.bin><encoding='GBK'>
注意：一个汉字以及汉字标点相当于两个字节，汉化文本字节数必须与英文字节数相等，多余部分可用空格补充。不要用英文标点，千万不要用“\\”
如果存在一句话字节数过多，请在※上一条目※的将IsCombined调为True，以及游戏进行时两句话输出在同一对话框中，也要将IsCombined调为True*/
""")
        while True:
            byte = InFile.read(1)
            offset += 1
            if byte == b'':
                break
            if byte == b'"':
                while (True):
                    lastbyte = byte
                    byte = InFile.read(1)
                    offset += 1
                    if not byte.isascii() or byte == b'\x00':
                        loop = False
                        break
                    if byte == b'"' and lastbyte != b'\\':
                        loop = True
                        break
                    EnglishStr.append(byte.decode("ascii"))
                if loop:
                    index += 1
                    OutFile.write(stringModel.format(offset-len(EnglishStr),len(EnglishStr),index,"".join(EnglishStr)))
                EnglishStr.clear()
        print(f"成功：Episode{i:02}.bin.txt")
        InFile.close()
        OutFile.flush()
        OutFile.close()

if __name__ == "__main__":
    Text2Bin(1,18)
    os.system("pause")
