
from django.shortcuts import render



def main_page(request):
    '''Вывод основной страницы
    :param request:
    :return:
    '''
    #return render(request, 'main/index.html', )
    return render(request, 'main/index2.html', )
